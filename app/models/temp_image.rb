class TempImage < ApplicationRecord

    has_one_attached :image, dependent: false
    
    def destroy_with_image
        self.transaction do
            image.purge
            self.destroy
        end
    end
end
