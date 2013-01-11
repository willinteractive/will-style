class StaticPagesController < ApplicationController
  
  
  def home
    @title = "Home";
  end

  def buttons
    @title = "Buttons & Colors";
  end

  def forms
    @title = "Forms";
  end

  def other
    @title = "Other";
  end
  
  def icons
    @title = "Icons";
  end
  
  def general
    @title = "General Elements";
  end
  
  def tables
    @title = "Tables";
  end
  
  def dashboard
    @title = "Dashboard";
  end
  
  def dashboard2
    @title = "Dashboard with Sidebar";
  end
  
end
