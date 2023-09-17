from rest_framework import status
from rest_framework.response import Response
from .serializers import UserSerializer, TempUserSerializer
from rest_framework.viewsets import GenericViewSet
from rest_framework.decorators import action
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import TokenError
from .models import User, SignupTemp
from django.forms.models import model_to_dict
from django.db.models import Q
import requests
import json

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
            return Response({'error_message' : 'User already exist'})
        return Response({'error_meassage' : 'Unable to create'})
    
    # verifing otp and performing auto-login and sending access token in response 
    @action(detail=False, methods=['POST'])
    def verify_otp(self, request):
        user = SignupTemp.objects.filter(email = request.data.get('email'), otp = request.data.get('otp')).first()
        if user:
            user_data = model_to_dict(user)
            user_data.pop('otp')
            serializer = UserSerializer(data=user_data, context = {'request' : request})
            if serializer.is_valid(raise_exception=True,):
                user = serializer.save()
                url = 'http://127.0.0.1:8000/user/login/' # url path has to be change when code goes for futher devlopment
                payload = {
                    'email' : user_data['email'],
                    'password' : user_data['password']
                }
                response = requests.post(url=url,json=payload)
                if response.status_code == 200:
                    response_data = json.loads(response.text)
                    response_data = {
                        'token' : response_data['data'],
                        'login_response' : 'OK'
                    }
                    return Response(response_data, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)

    # user login 
    @action(detail=False, methods=['POST'])
    def login(self, request):
        serializer = TokenObtainPairSerializer(data = request.data)
        if serializer.is_valid():
            return Response({'data' : serializer.validated_data}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Invalid username or password'})
    
    @action(detail=False, methods=['POST'])
    def logout(self, request):
        try:
            token = RefreshToken(request.data.get("refresh"))
            token.blacklist()
        except TokenError:
            return Response({"error": "Invalid token."})
        return Response({"success_message": "Successfully logged out."})
    
    # ToDo : Forget Password API


