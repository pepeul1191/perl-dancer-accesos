# encoding: utf-8

require_relative 'app'
require 'json'

def mandar_desde_web
    file = File.new("data/correo_web.txt", "r")
    arreglo_correos = []
    while (line = file.gets)
        data_json_string = line
        arreglo_correos.push(data_json_string)
    end
    RSpec.describe App do
        describe "1. Mandar correo desde el formulario web de contacto: " do
            arreglo_correos.each do |correo|
                it '1.1 Conexión con backend-animalitos' do
                  test =App.new('')
                  test.servicios('backend', 'test/conexion')
                  expect(test.response.code).to eq(200)
                end
                it '1.2 Guardar correo en base de datos' do
                    url = 'correo/mandar?correo='+correo
                    test = App.new(url)
                    test.post()
                    expect(test.response.body).not_to include('error')
                    expect(test.response.body).to include('Correo OK', '"tipo_mensaje":"success"')
                end
            end
        end
    end
end

mandar_desde_web