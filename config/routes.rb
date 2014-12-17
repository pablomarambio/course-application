Rails.application.routes.draw do

  root to: 'visitors#index'

  devise_for :users, :skip => :registrations

  get "/admin/applications/download", as: "download_applications"
  get "/applications/incomplete", as: "incomplete_applications"
  get "/students/idle", as: "idle_students"

  mount Upmin::Engine => '/admin'

  Upmin::Engine.routes.draw do
    resources :upload, only:[:create, :show]
    get "/upload/new/:type" => "upload#new", as: "new_upload"
  end

end