##
# Namespace module.
#
module WILL

  ##
  # Namespace module.
  #
  module Style

    ##
    # Helpers for generating HTML elements
    module ComponentsHelper   
    end
  end
end

include WILL::Style::Foundation::AlertHelper
include WILL::Style::Foundation::TooltipHelper
include WILL::Style::Foundation::ModalHelper
include WILL::Style::Foundation::DropdownHelper

include WILL::Style::Components::SidebarHelper
include WILL::Style::Components::SearchHelper
