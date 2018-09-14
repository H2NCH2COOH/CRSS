Rails.application.routes.draw do
  get '/:uname' => 'crss#feed'
  put '/:uname' => 'crss#reg'
  post '/:uname' => 'crss#new'
  get '/' => redirect('/crss/main.html')
end
