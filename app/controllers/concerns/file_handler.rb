module FileHandler
    extend ActiveSupport::Concern

    def to_file(required_params)
        params = file_params(required_params)
        file = params[:data]
        url = params[:url]

        return meta(file) if file
        return meta_from_url(url) if url
        return
    end

    private

    def file_params(required_params)
        required_params.permit(file: [:url, :data]).to_h.deep_symbolize_keys[:file]
    end

    def meta_from_url(url)
        return unless url
        return unless url =~ URI::regexp

        uri = URI.parse(url)
        path = uri.path
        extname = File.extname(path)
        extname = extname.blank? ? '.jpg' : extname
        basename = File.basename(path, extname)

        file = Tempfile.new([basename, extname])
        file.binmode
        file.write open(uri).read
        file.rewind

        name = file_name(path)
        content_type = file_type(name)

        return file, name, content_type
    end

    def file_name(uri_path)
        extname = File.extname(uri_path)
        File.basename(uri_path, extname) + extname
    end

    def file_type(file)
        MIME::Types.type_for(file).first.content_type
    end

    def meta(file)
        return file, file.original_filename, file.content_type
    end
end