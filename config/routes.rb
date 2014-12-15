Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users, :skip => :registrations
  get "/admin/students/upload", as: "upload_students"
  get "/admin/courses/upload", as: "upload_courses"
  get "/admin/results/upload", as: "upload_results"
  get "/admin/applications/download", as: "download_applications"
  get "/applications/incomplete", as: "incomplete_applications"
  get "/students/idle", as: "idle_students"
end