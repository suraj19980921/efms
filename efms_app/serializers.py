from rest_framework import serializers
from .models import Feed, Comment, Like, User

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['comment_text', 'created_at', 'user_id']

class FeedsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feed
        fields = '__all__'
        extra_kwargs = {
                        'user_id' : {'read_only' : True}
                       }

    # celar the concept of saving data wether it should be done on views or serilaizers
    def create(self, validated_data):
        validated_data['user_id'] = self.context['request'].user
        return super(FeedsSerializer, self).create(validated_data)

    def to_representation(self, instance):
        data = super().to_representation(instance)
        extra_data = dict()
        like_instance = Feed.objects.prefetch_related('feed_like').get(pk=instance.pk)
        feeds = like_instance.feed_like.first()
        total_likes = 0
        if feeds:
            total_likes = feeds.user_id.count()
        if total_likes > 0:
            extra_data['total_likes'] = total_likes
        comments_instance = Feed.objects.prefetch_related('feed_comment').get(pk=instance.pk)
        comments_data = comments_instance.feed_comment.all()
        if comments_data:
            extra_data['comments'] = CommentSerializer(comments_instance.feed_comment.all(), many=True).data
        data.update(extra_data)
        return data