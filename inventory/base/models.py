from django.db import models

# Create your models here.
class Store(models.Model):
    name = models.CharField(max_length=30)


class Supplier(models.Model):
    name = models.CharField(max_length=30)


class Product(models.Model):
    description = models.CharField(max_length=100)
    price = models.DecimalField(decimal_places=2, max_digits=20)

