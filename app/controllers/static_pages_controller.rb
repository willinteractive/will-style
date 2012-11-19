class StaticPagesController < ApplicationController
  def home
    @title = "help";
  end

  def buttons
    render :layout => 'admin';
  end

  def forms
    render :layout => 'admin';
  end

  def other
    render :layout => 'admin';
  end
  
  def icons
    render :layout => 'admin';
  end
  
  def general
    render :layout => 'admin';
  end
  
  def tables
    render :layout => 'admin';
  end
  
  def dashboard
     render :layout => 'admin';
  end
  
end
