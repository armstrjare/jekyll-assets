module Jekyll
  module Assets
    module Liquid
      class Tag
        module Proxies
          def self.add_by_class(_class, name, tag, *args)
            names = [name, name.to_s, name.to_sym]
            tags  =  [tag].flatten.map { |v| [v.to_s, v, v.to_sym] }
            args  = [args].flatten.map { |v| [v.to_s, v, v.to_sym] }

            all << {
              :name => names.uniq,
              :tags => tags.flatten.uniq,
              :args => args.flatten.uniq,
              :class  => _class
            }
          all
          end

          # -------------------------------------------------------------------

          def self.add(name, tag, *args, &block)
            add_by_class(*generate_class(name, tag, &block), *args)
          end

          # -------------------------------------------------------------------

          def self.keys
            all.select { |val| !val.fetch(:class).is_a?(Symbol) }.map do |v|
              v[:name]
            end. \
            flatten
          end

          # -------------------------------------------------------------------

          def self.base_keys
            all.select { |val| val.fetch(:class).is_a?(Symbol) }.map do |v|
              v[:name]
            end. \
            flatten
          end

          # -------------------------------------------------------------------

          def self.has?(name, tag = nil, arg = nil)
            get(name, tag, arg).any?
          end

          # -------------------------------------------------------------------

          def self.get(name, tag = nil, arg = nil)
            if name && tag && arg
              get_by_name_and_tag_and_arg(
                name, tag, arg
              )
            elsif name && tag
              get_by_name_and_tag(
                name, tag
              )
            else
              all.select do |val|
                val.fetch(:name).include?(name)
              end
            end
          end

          # -------------------------------------------------------------------

          def self.get_by_name_and_tag_and_arg(name, tag, arg)
            all.select do |val|
              (val.fetch(:name).include?(name))   && \
              (val.fetch(:tags).include?(:all)    || \
                  val.fetch(:tags).include?(tag)) && \
              (val.fetch(:args).include?( arg))
            end
          end

          # -------------------------------------------------------------------

          def self.get_by_name_and_tag(name, tag)
            all.select do |val|
              (val.fetch(:name).include?(name))   &&
              (val.fetch(:tags).include?(:all)    || \
                  val.fetch(:tags).include?(tag))
            end
          end

          # -------------------------------------------------------------------

          def self.all
            @_all ||= Set.new
          end

          # -------------------------------------------------------------------

          private
          def self.generate_class(name, tag, &block)
            _class = const_set(random_name, Class.new)
            _class. class_eval(&block)
            return _class, name, tag
          end

          # -------------------------------------------------------------------

          private
          def self.random_name
            (0...12).map { ("a".."z").to_a.values_at(rand(26)) }.join.capitalize
          end

          # -------------------------------------------------------------------

          # TODO: Put in a better place.
          add_by_class :internal, :data, :all, ["@uri"]
          add_by_class :internal, :sprockets, :all, [
            "accept", "write_to"
          ]
        end
      end
    end
  end
end
