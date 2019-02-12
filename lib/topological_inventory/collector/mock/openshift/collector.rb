require "topological_inventory/collector/mock/collector"
require "topological_inventory/collector/mock/openshift/parser"
require "topological_inventory/collector/mock/openshift/server"

module TopologicalInventory
  module Collector
    module Mock
      module Openshift
        class Collector < ::TopologicalInventory::Collector::Mock::Collector
          def path_to_config
            File.expand_path("../../../../../config/openshift", File.dirname(__FILE__))
          end

          def connection
            @connection ||= TopologicalInventory::Collector::Mock::Openshift::Server.new
          end

          def collector_thread(entity_type)
            full_refresh(entity_type)

            # Stop if full refresh only
            return if ::Settings.refresh_mode == :full_refresh

            # Watching events (targeted refresh)
            if %i(standard events).include?(::Settings.refresh_mode)
              watch(entity_type, nil) do |notice|
                log.info("#{entity_type} #{notice.object.metadata.name} was #{notice.type.downcase}")
                queue.push(notice)
              end
            end
          rescue => err
            log.error(err)
          end

          def full_refresh(entity_type)
            (::Settings.full_refresh&.repeats_count || 1).to_i.times do |cnt|
              log.info("Collecting #{entity_type}: round #{cnt}")
              super(entity_type)
            end
          end

          def entity_types
            case ::Settings.full_refresh.send_order
            when :normal then
              TopologicalInventory::Collector::Mock::Openshift::Storage.entity_types
            when :reversed then
              TopologicalInventory::Collector::Mock::Openshift::Storage.entity_types.reverse
            else
              raise "Send order :#{::Settings.send_order} of entity types unknown. Allowed values: :normal, :reversed"
            end
          end

          def parser_class
            TopologicalInventory::Collector::Mock::Openshift::Parser
          end
        end
      end
    end
  end
end
