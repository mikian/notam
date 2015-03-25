Rails.application.routes.draw do
  resource :notam, only: [] do
    post :show, on: :collection
    get :upload, on: :collection
  end

  root to: redirect('/notam/upload')
end
