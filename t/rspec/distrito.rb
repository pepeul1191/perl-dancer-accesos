# encoding: utf-8

require_relative 'app'
require 'json'

def buscar
    RSpec.describe App do
        describe "1. Registrar Información Personal : " do
            it '1.1 Conexión con backend-animalitos' do
              test =App.new('')
              test.servicios('backend', '/test/conexion')
              expect(test.response.code).to eq(200)
            end
            it '1.2 Buscar "L"' do
                url = 'distrito/buscar?nombre=L'
                test = App.new(url)
                test.get()
                expect(test.response.body).not_to include('error')
                resultado = JSON.parse(test.response.body)
                expect(resultado.length).to eq(10)
            end
            it '1.3 Buscar "La"' do
                url = 'distrito/buscar?nombre=La'
                test = App.new(url)
                test.get()
                expect(test.response.body).not_to include('error')
                resultado = JSON.parse(test.response.body)
                expect(resultado.length).to eq(10)
            end
            it '1.4 Buscar "La V"' do
                url = 'distrito/buscar?nombre=La V'
                test = App.new(url)
                test.get()
                expect(test.response.body).not_to include('error')
                resultado = JSON.parse(test.response.body)
                expect(resultado.length).to eq(2)
            end
            it '1.5 Buscar "La Victoria"' do
                url = 'distrito/buscar?nombre=La Vict'
                test = App.new(url)
                test.get()
                expect(test.response.body).not_to include('error')
                resultado = JSON.parse(test.response.body)
                expect(resultado.length).to eq(2)
            end
             it '1.6 Buscar "La Victoria, L"' do
                url = 'distrito/buscar?nombre=La Victoria, L'
                test = App.new(url)
                test.get()
                expect(test.response.body).not_to include('error')
                resultado = JSON.parse(test.response.body)
                expect(resultado.length).to eq(1)
            end
        end
    end
end



$i = 0
$num = 10

while $i < $num  do
   buscar
   $i +=1
end