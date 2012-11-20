class StaticPagesController < ApplicationController
  
  
  def home
    @title = "Home";
  end

  def buttons
    @title = "Buttons & Colors";
    @products = Product.all;
    render :layout => 'admin';
  end

  def forms
    @title = "Forms";
    @products = Product.all;
    render :layout => 'admin';
  end

  def other
    @title = "Other";
    @products = Product.all;
    render :layout => 'admin';
  end
  
  def icons
    @title = "Icons";
    @products = Product.all;
    render :layout => 'admin';
  end
  
  def general
    @title = "General Elements";
    @products = Product.all;
    render :layout => 'admin';
  end
  
  def tables
    @title = "Tables";
    @products = Product.all;
    render :layout => 'admin';
  end
  
  def dashboard
    @title = "Dashboard";
    @products = Product.all;
    render :layout => 'admin';
  end
  
end
