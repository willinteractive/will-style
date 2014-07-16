##
# Namespace module.
#
module WILL

  ##
  # Namespace module.
  #
  module Style

    ##
    # Helpers for generating Foundation HTML elements
    module FoundationHelper   
    end
  end
end

include WILL::Style::Foundation::AlertHelper
include WILL::Style::Foundation::TooltipHelper
include WILL::Style::Foundation::ModalHelper
include WILL::Style::Foundation::DropdownHelper
