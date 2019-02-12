require "active_support/inflector"

module TopologicalInventory
  module Collector
    module Mock
      class Parser
        attr_accessor :collections, :resource_timestamp

        def initialize
          self.resource_timestamp = Time.now.utc
        end

        def lazy_find(collection, reference, ref: :manager_ref)
          TopologicalInventoryIngressApiClient::InventoryObjectLazy.new(
            :inventory_collection_name => collection,
            :reference                 => reference,
            :ref                       => ref,
          )
        end
      end
    end
  end
end
