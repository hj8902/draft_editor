class TempsController < ApplicationController

    def create
        file, name, content_type = to_file(temp_params)
        raise Exception.new('file parameter has to be passed!') unless file

        temp = TempImage.new

        TempImage.transaction do
            temp.image.attach(io: file, filename: name, content_type: content_type) if temp.save
        end

        json_response({ temp: temp_image_view(temp) })
    end

    def destroy
        json_response unless params[:id]

        temp = TempImage.find_by(id: params[:id])
        json_response unless temp

        temp.destroy_with_image
        json_response
    end

    def truncate
        TempImage.where(id: temp_params[:ids].split(',')).each do |temp|
            temp.destroy_with_image
        end

        json_response
    end

    private

    def temp_image_view(temp)
        image = temp.image
        view = temp.as_json
        view.merge({ link: url_for(image), type: image.content_type })
    end

    def temp_params
        params.require(:temp)
    end
end
