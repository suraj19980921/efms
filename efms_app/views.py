from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import GenericViewSet
from rest_framework.decorators import action
from .pagination import FeedsPagination, TicketsPagination
from .models import Feed, Ticket
from .serializers import FeedsSerializer, TicketSerializer
from rest_framework import status
from django.db.models import Count

class TicketsViewset(GenericViewSet):
    pagination_class = TicketsPagination
    
    @action(detail=False, methods=["GET"])
    def get_tickets(self, request):
        status = request.data.get('status')
        tickets_count_data = Ticket.objects.values('status').annotate(count = Count('status')).filter(user_id = request.user)
        tickets_count_by_status = {data['status'] : data["count"] for data in tickets_count_data}
        if status is None :
            tickets = Ticket.objects.filter(user_id = request.user).order_by('created_at')
            raised_tickets = tickets.filter(status = 1)
            page = self.paginate_queryset(raised_tickets)
            if page is not None:
                raised_tickets_serializer = TicketSerializer(page, many=True)
                raised_tickets_response = self.get_paginated_response(raised_tickets_serializer.data).data

            picked_tickets = tickets.filter(status = 2)
            page = self.paginate_queryset(picked_tickets)
            if page is not None:
                picked_tickets_serializer = TicketSerializer(page, many=True)
                picked_tickets_response = self.get_paginated_response(picked_tickets_serializer.data).data
            
            dispatched_tickets = tickets.filter(status = 3)
            page = self.paginate_queryset(dispatched_tickets)
            if page is not None:
                dispatched_tickets_serializer = TicketSerializer(page, many=True)
                dispatched_tickets_response = self.get_paginated_response(dispatched_tickets_serializer.data).data
            
            destroyed_tickets = tickets.filter(status = 4)
            page = self.paginate_queryset(destroyed_tickets)
            if page is not None:
                destroyed_tickets_serializer = TicketSerializer(page, many=True)
                destroyed_tickets_response = self.get_paginated_response(destroyed_tickets_serializer.data).data
            
            response_dict = {
                'raised_tickets' : {
                    'count' : tickets_count_by_status[1],
                    'data' : raised_tickets_response
                },
                'picked_tickets' : {
                    'count' : tickets_count_by_status[2],
                    'data' : picked_tickets_response
                },
                'dispatched_tickets' : {
                    'count' : tickets_count_by_status[3],
                    'data' : dispatched_tickets_response
                },
                'destroyed_tickets' : {
                    'count' : tickets_count_by_status[4],
                    'data' : destroyed_tickets_response
                }
            }
            return Response(response_dict)
        else:
            tickets = Ticket.objects.filter(user_id = request.user, status = status).order_by('created_at')
            page = self.paginate_queryset(picked_tickets)
            if page is not None:
                tickets_serializer = TicketSerializer(page, many=True)
                return self.get_paginated_response(tickets_serializer.data)

    @action(detail=False, methods=["POST"])
    def create_ticket(self, request):
        tickets_serializer = TicketSerializer(data=request.data, context = {'request' : request})
        if tickets_serializer.is_valid(raise_exception=True):
            tickets_serializer.save()
            return Response({'sucess_message' : 'Ticket sucessfully created.'}, status=status.HTTP_201_CREATED)
        return Response({'error_message' : 'Unable to create ticket.'})
    
    @action(detail=False, methods=["POST"])
    def update_ticket(self, request):
        ticket_object = Ticket.objects.filter(id = request.data['id']).first()
        tickets_serializer = TicketSerializer(ticket_object, data=request.data, partial=True)
        if tickets_serializer.is_valid(raise_exception=True):
            tickets_serializer.save()
            return Response({'sucess_message' : 'Ticket sucessfully udated.'}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Unable to update ticket.'})

    @action(detail=False, methods=["POST"])
    def delete_ticket(self, request):
        if Ticket.objects.get(id = request.data['id']).delete():
            return Response({'sucess_message' : 'Ticket deleted sucessfully.'}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Something went wrong.'}, status=status.HTTP_400_BAD_REQUEST)
    

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
    def update_feed(self, request):
        feed_object = Feed.objects.filter(id = request.data['id']).first()
        feed_serializer = FeedsSerializer(feed_object, data=request.data, partial=True)
        if feed_serializer.is_valid(raise_exception=True):
            feed_serializer.save()
            return Response({'sucess_message' : 'Feed sucessfully udated.'}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Unable to update feed.'})

    @action(detail=False, methods=["POST"])
    def delete_feeds(self, request):
        if Feed.objects.get(id = request.data['id']).delete():
            return Response({'sucess_message' : 'Feed deleted sucessfully.'}, status=status.HTTP_200_OK)
        return Response({'error_message' : 'Something went wrong.'}, status=status.HTTP_400_BAD_REQUEST)
