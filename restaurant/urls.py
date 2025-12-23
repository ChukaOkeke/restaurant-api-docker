from django.urls import path
from . import views

# Define URL routes for the restaurant app
urlpatterns = [
    path('', views.index, name='index')
]