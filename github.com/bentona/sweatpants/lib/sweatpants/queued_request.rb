
module Sweatpants
  class QueuedRequest

    def initialize method, params
      @method = method
      @type = params[:type] || nil
      @index = params[:index] || nil
      @id = params[:id] || nil
      @body = params[:body] || nil
    end

    def to_bulk
      [bulk_header, @body].map(&:to_json).join("\n")
    end

    def bulk_header
      header = { @method.to_sym => { _index: @index, _type: @type } }
      header[:id] = @id if @id
      header
    end
  end
end