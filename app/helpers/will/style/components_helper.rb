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
    #
    module ComponentsHelper
    end
  end
end

include WILL::Style::Components::HideableSidebarHelper
include WILL::Style::Components::PageHeaderHelper
include WILL::Style::Components::ListGroupHelper
