ActiveAdmin.register Brand do
  menu label: I18n.t('activerecord.models.brand.other')
  filter :name, :state

  permit_params :name, :state

  form title: I18n.t('activerecord.models.brand.one') do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :state
    end
    f.actions
  end

  show do
    byebug
    attributes_table do
      row :name
      row :state
    end

    #   active_admin_comments
  end
  #
  # index do
  #   selectable_column
  #   id_column
  #   column :name
  #   column :state
  #   actions
  # end
  #
  #
  controller do
    # def index
    #   @collection = []
    # end

    #    def show
      #  @brand = Brand.new({ id: '1', name: 'Name', state: 'STATE' })
    #end
  end
end
