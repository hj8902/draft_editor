class ContentsController < ApplicationController

    def create
        value = content_params[:value] || ''
        temp_ids = temp_params[:ids] || []

        content = Content.new(value: value)
        content.transaction do
            content.save
            unless temp_ids.empty?
                temps = TempImage.where(id: temp_ids)
                temps.each { |temp| content.images.attach temp.image.blob }
                temps.destroy_all
            end
        end

        json_response
    end

    def content_params
        params.require(:content).permit(:value)
    end

    def temp_params
        params.require(:temp).permit(:ids)
    end
end
