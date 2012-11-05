module ActiveHash
  class SQLQueryExecutor
    class << self
      def execute(klass, query)
        @operator, @sub_query, @objects = process_first(klass, query, query.split(" ")[1])

        @operator.nil? ? @objects : @objects.send(@operator, execute(klass, @sub_query)).sort_by{ |o| o.id }
      end

      def process_first(klass, query, operator)
          query = sanitize_query(query)

          array = query.split(" ")
          sub_query = case operator
            when "between"
              array[0..5]
            when "is"
              size = array[2].downcase == "not" ? 4 : 3
              array[0..size]
            else
              operator = "==" if operator == "="
              array[0..3]
            end

          binding_operator = get_operator(sub_query)

          objects = case operator
            when "between"
              klass.all.select{ |o| (o.send(sub_query.first).is_a?(Integer) ? (o.send(sub_query.first) >= sub_query[2].gsub("_", " ").to_i && o.send(sub_query.first) <= sub_query[4].gsub("_", " ").to_i) : (o.send(sub_query.first).to_s) >= sub_query[2].gsub("_", " ") && o.send(sub_query.first) <= sub_query[4].gsub("_", " ")) }
            when "is"
              klass.all.select{ |o| sub_query.size == 3 ? o.send(sub_query.first).blank? : !o.send(sub_query.first).blank? }
            else
              klass.all.select{ |o| o.send(sub_query.first).nil? ? false : o.send(sub_query.first).to_s.send(operator, sub_query[2].gsub("_", " ")) }
            end

          sub_query = query.gsub(sub_query.join(" "), "")

          [binding_operator, sub_query, objects]
      end

      def args_to_query(args)
        return args.first if args.size == 1

        query = args.first
        param = args.delete(args[1])

        case param.class.name
        when "String"
          param = "'#{param}'"
        when "Date"
          param = "'#{param.strftime("%Y-%m-%d")}'"
        when "Time"
          param = "'#{param.strftime("%Y-%m-%d %H:%M:%S %z")}'"
        else
          param = param.to_s
        end

        args[0] = query.sub("?", param)

        args_to_query(args)
      end

      private
      def get_operator(attributes)
        operator = attributes.size >= 4 ? attributes.last : nil

        case operator
        when "or"
          "+"
        when "and"
          "&"
        else
          nil
        end
      end

      def sanitize_query(query)
        new_query = query
        params = query.scan(/([\"'])(.*?)\1/)

        params.each do |quote, param|
          new_query = new_query.gsub(quote,"").gsub(param, param.gsub(" ", "_"))
        end

        new_query
      end
    end
  end
end