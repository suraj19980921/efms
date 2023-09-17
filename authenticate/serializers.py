from rest_framework import serializers
from services import generate_otp, send_otp_email
from .models import User, SignupTemp

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'password', 'access_role', 'address', 'phone_no']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(
            first_name = validated_data['first_name'],
            last_name = validated_data['last_name'],
            email = validated_data['email'],
            phone_no = validated_data['phone_no'],
            access_role = validated_data['access_role'],
            address = validated_data['address']

        )
        user.set_password(validated_data['password'])
        user.save()
        return user

class TempUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = SignupTemp
        fields = ['first_name', 'last_name', 'email', 'password', 'access_role', 'address', 'phone_no', 'otp']
        extra_kwargs = {'password': {'write_only': True},
                        'otp' : {'read_only' : True}
                       }

    def create(self, validated_data):
        otp = generate_otp()
        user = SignupTemp(
            first_name = validated_data['first_name'],
            last_name = validated_data['last_name'],
            email = validated_data['email'],
            phone_no = validated_data['phone_no'],
            access_role = validated_data['access_role'],
            address = validated_data['address'],
            password = validated_data['password'],
            otp = otp
        )
        user.save()
        send_otp_email(validated_data['email'], otp)
        return user