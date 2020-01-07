class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do 
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do 
    @pet = Pet.create(name: params["pet_name"])

    if(params[:owner_id])
      @owner = Owner.find(params[:owner_id])
    elsif(params[:owner_name])
      @owner = Owner.create(name: params[:owner_name])
    end

    @pet.owner_id = @owner.id
    @pet.save
    @owner.pets << @pet
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
    @pet = Pet.find(params[:id])
    @owners = Owner.all
    erb :'/pets/edit'
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  patch '/pets/:id' do 
    @pet = Pet.find(params[:id])
    @pet.update(name: params[:pet_name])

    if !params["owner"]["name"].empty?
      @owner = Owner.create(name: params["owner"]["name"])
      @owner.pets << @pet
      @pet.owner_id = @owner.id
    elsif params[:owner_id]
      @owner = Owner.find(params[:owner_id])
      @owner.pets << @pet
      @pet.owner_id = @owner.id
    end

    redirect to "pets/#{@pet.id}"
  end
end