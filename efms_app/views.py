from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import GenericViewSet
from rest_framework.decorators import action
from .pagination import FeedsPagination
from .models import Feed, Ticket
from .serializers import FeedsSerializer
from rest_framework import status

class FeedsViewset(GenericViewSet):
    # permission_classes = (IsAuthenticated)
    pagination_class = FeedsPagination

    @action(detail=False, methods=["GET"])
    def get_feeds(self, request):
        feeds = Feed.objects.all().order_by('created_at')
        page = self.paginate_queryset(feeds)
        if page is not None:
            serializer = FeedsSerializer(page, many=True)
            return self.get_paginated_response(serializer.data)
        serializer = FeedsSerializer(feeds, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=["POST"])
    def create_feeds(self, request):
        serialzer = FeedsSerializer(data=request.data, context = {'request' : request})
        if serialzer.is_valid(raise_exception=True):
            serialzer.save()
            return Response({'sucess_message' : 'Feed sucessfully created.'}, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=["POST"])
    def delete_feeds(self, request):
        if Feed.objects.get(id = request.data['id']).delete():
            return Response({'sucess_message' : 'Feed deleted sucessfully.'}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Something went wrong.'}, status=status.HTTP_400_BAD_REQUEST)
