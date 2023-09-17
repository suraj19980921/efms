# Generated by Django 4.2.5 on 2023-09-17 09:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authenticate', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='SignupTemp',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('first_name', models.CharField(max_length=100)),
                ('last_name', models.CharField(max_length=100)),
                ('password', models.CharField(max_length=200)),
                ('email', models.EmailField(max_length=254)),
                ('access_role', models.IntegerField(choices=[(1, 'SUPERADMIN'), (2, 'ADMIN'), (3, 'SUB-ADMIN')], default=3)),
                ('address', models.CharField(max_length=200)),
                ('phone_no', models.IntegerField()),
                ('otp', models.IntegerField(unique=True)),
            ],
        ),
    ]
