from rest_framework import serializers
from services import generate_otp, send_otp_email
from .models import User, SignupTemp
from django.contrib.auth.hashers import make_password

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'password', 'access_role', 'address', 'phone_no']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(
            first_name = validated_data.get('first_name'),
            last_name = validated_data.get('last_name'),
            email = validated_data.get('email'),
            password = validated_data.get('password'),
            phone_no = validated_data.get('phone_no'),
            access_role = validated_data.get('access_role'),
            address = validated_data.get('address')
        )
        user.save()
        return user

class TempUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = SignupTemp
        fields = ['first_name', 'last_name', 'email', 'password', 'access_role', 'address', 'phone_no', 'otp']
        extra_kwargs = {
                        'otp' : {'read_only' : True}
                       }

    def create(self, validated_data):
        otp = generate_otp()
        user = SignupTemp(
            first_name = validated_data.get('first_name'),
            last_name = validated_data.get('last_name'),
            email = validated_data.get('email'),
            password = make_password(validated_data.get('password')),
            phone_no = validated_data.get('phone_no'),
            access_role = validated_data.get('access_role'),
            address = validated_data.get('address'),
            otp = otp
        )
        user.save()
        # send_otp_email(validated_data.get('email'), otp)
        return user

class ChangePasswordSerializer(serializers.Serializer):
    new_password = serializers.CharField(required=True)