class StaticPagesController < ApplicationController
  
  
  def home
    @title = "Home";
  end

  def buttons
    @title = "Buttons & Colors";
    @products = Product.all;
  end

  def forms
    @title = "Forms";
    @products = Product.all;
  end

  def other
    @title = "Other";
    @products = Product.all;
  end
  
  def icons
    @title = "Icons";
    @products = Product.all;
  end
  
  def general
    @title = "General Elements";
    @products = Product.all;
  end
  
  def tables
    @title = "Tables";
    @products = Product.all;
  end
  
  def dashboard
    @title = "Dashboard";
    @products = Product.all;
  end
  
end
