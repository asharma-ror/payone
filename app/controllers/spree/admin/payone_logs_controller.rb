module Spree
  module Admin
    class PayoneLogsController < ResourceController
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end
      
      def clear
        Spree::PayoneLog.destroy_all
        respond_with(@collection) do |format|
          format.html { redirect_to collection_url }
          format.json { render :json => json_data }
        end
      end
      
      protected

        def collection
          return @collection if @collection.present?
          
          # Use default sort by created_at desc if not provided
          params[:q] = {} unless params.has_key?(:q)
          if !params[:q].has_key?(:s) || (params[:q].has_key?(:s) && params[:q][:s].to_s.empty?)
            params[:q][:s] = "created_at desc"
          end
          
          unless request.xhr?
            @search = Spree::PayoneLog.search(params[:q])
            @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
          else
            @collection = Spree::PayoneLog.
                              where("spree_payone_logs.message #{LIKE} :search
                                     OR spree_payone_logs.level #{LIKE} :search",
              { :search => "#{params[:q].strip}%" }).
                limit(params[:limit] || 100)
          end
        end

      private
        
        # Allows different formats of json data to suit different ajax calls.
        def json_data
          json_format = params[:json_format] or 'default'
          case json_format
          when 'basic'
            collection.map { |u| { 'id' => u.id, 'name' => u.message } }.to_json
          else
            collection.to_json(:only => [:id, :level, :message])
          end
        end
    end
  end
end