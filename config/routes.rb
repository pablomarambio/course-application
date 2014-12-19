Rails.application.routes.draw do

  get 'public/index' => 'public#index'
  get 'public/students/idle' => 'public#idle_students', as: "idle_students"
  get 'public/applications/incomplete' => 'public#incomplete_applications', as: "incomplete_applications"
  get 'public/courses/available' => 'public#available_courses', as: "available_courses"
  get 'public/batches' => 'public#batches', as: "batches"

  root to: 'public#index'

  devise_for :users, :skip => :registrations

  mount Upmin::Engine => '/admin'

  Upmin::Engine.routes.draw do
    resources :upload, only:[:create, :show]
    get "/downolad/applications" => "download#applications", as: "download_applications"
    get "/upload/new/:type" => "upload#new", as: "new_upload"
  end

end