require "topological_inventory/collector/mock/entity"
require "recursive-open-struct"

module TopologicalInventory
  module Collector
    module Mock
      module Openshift
        class Entity < ::TopologicalInventory::Collector::Mock::Entity
          attr_reader :labels

          def initialize(_id, _entity_type)
            super

            # metadata
            @labels      = self.class.labels
            @annotations = self.class.annotations
          end

          def metadata
            self
          end

          def self.annotations
            {
              :"node.openshift.io/md5sum"                               => "d59c38bb2c2e6553a869752ba72d3a6c",
              :"volumes.kubernetes.io/controller-managed-attach-detach" => "true"
            }
          end

          # labels are optional,
          # generated for each even
          def self.labels
            {
              :"mock/openshift" => "true"
            }
          end
        end
      end
    end
  end
end
