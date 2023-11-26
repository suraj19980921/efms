from rest_framework import status
from rest_framework.response import Response
from .serializers import UserSerializer, TempUserSerializer, ChangePasswordSerializer
from rest_framework.viewsets import GenericViewSet
from rest_framework.decorators import action
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import TokenError
from .models import User, SignupTemp
from django.contrib.auth import login
from django.db.models import Q

# Create your views here.

class UserViewSet(GenericViewSet):
    queryset = User.objects.all()

    # saving data in temp table and sending otp
    @action(detail=False, methods=["POST"])
    def signup(self, request):
        user = User.objects.filter(Q(email = request.data['email']) | Q(phone_no = request.data['phone_no']))
        if not user:
            serializer = TempUserSerializer(data=request.data, context = {'request' : request})
            if serializer.is_valid(raise_exception=True):
                serializer.save()
                response = {
                    'otp' : serializer.data["otp"],
                    'user_email' : serializer.data['email'],
                    'success_message' : 'OTP is sent to your mail'
                }
                return Response(response, status=status.HTTP_200_OK)
        else:
            return Response({'error_message' : 'User already exist'}, status=status.HTTP_208_ALREADY_REPORTED)
        return Response({'error_meassage' : 'Unable to create'}, status=status.HTTP_400_BAD_REQUEST)
    
    # verifing otp and performing auto-login and sending access token in response 
    @action(detail=False, methods=['POST'])
    def verify_otp(self, request):
        action = request.query_params.get('action')
        user = SignupTemp.objects.filter(email = request.data.get('email'), otp = request.data.get('otp')).first()
        temp_user_serializer= TempUserSerializer(user)
        if user:
            if action == 'forgot_password':
                return Response({'success_message': "OTP Verified successfully"}, status=status.HTTP_200_OK)
            user_serializer = UserSerializer(data = temp_user_serializer.data)
            if user_serializer.is_valid(raise_exception=True,):
                user = user_serializer.save()
                login(request, user)
                refresh = RefreshToken.for_user(user)
                access_token = str(refresh.access_token)
                response_data = {
                    'token': access_token,
                    'login_response': 'OK'
                }
                return Response(response_data, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)

    # user login 
    @action(detail=False, methods=['POST'])
    def login(self, request):
        serializer = TokenObtainPairSerializer(data = request.data)
        if serializer.is_valid():
            user = User.objects.filter(email = request.data['email']).first()
            user_serializer = UserSerializer(user)
            return Response({'token_data' : serializer.validated_data, 'user_data': user_serializer.data}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Invalid username or password'})
    
    @action(detail=False, methods=['POST'])
    def logout(self, request):
        try:
            if request.data.get("refresh"):
                token = RefreshToken(request.data.get("refresh"))
                token.blacklist()
            else:
                return Response({"error_message": "Token not received"}, status=status.HTTP_400_BAD_REQUEST)
        except TokenError:
            return Response({"error_message": "Invalid token."}, status=status.HTTP_400_BAD_REQUEST)
        return Response({"success_message": "Successfully logged out."}, status=status.HTTP_200_OK)
    
    # ToDo : Forget Password API
    @action(detail=False, methods=['POST'])
    def forgot_password(self, request):
        user = User.objects.filter(email = request.data.get('email'))
        if user:
            serializer = TempUserSerializer(data=request.data, context = {'request' : request})
            if serializer.is_valid(raise_exception=True):
                serializer.save()
                response = {
                    'otp' : serializer.data["otp"],
                    'user_email' : serializer.data['email'],
                    'success_message' : 'OTP is sent to your mail'
                }
                return Response(response, status=status.HTTP_200_OK)
        else:
            return Response({'error_mssage': 'User does not exist'}, status=status.HTTP_200_OK)
    
    @action(detail=False, methods=['POST'])
    def set_new_password(self, request):
        serializer = ChangePasswordSerializer(data={'new_password' : request.data.get('new_password')})
        if serializer.is_valid(raise_exception=True):
            user = User.objects.filter(email = request.data.get('email')).first()
            user.set_password(request.data.get('new_password'))
            user.save()
            return Response({'success_message' : 'Password Changed Successfully'}, status=status.HTTP_200_OK)
        return Response({'error_message': 'Unable to Change Password'}, status=status.HTTP_400_BAD_REQUEST)