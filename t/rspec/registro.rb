# encoding: utf-8

require_relative 'app'
require 'json'

def validar_usuario_repetido
    RSpec.describe App do
        describe "1. Validar nombre de usuario repetido - Verdadero : " do
            file = File.new("data/nombres_usuario_verdadero.txt", "r")
            arreglo_nombres_usuario = []
            while (line = file.gets)
                nombre_usuario = line
                arreglo_nombres_usuario.push(nombre_usuario)
            end

            arreglo_nombres_usuario.each do |nombre|
                it '1.1 Conexión con backend-animalitos' do
                  test =App.new('')
                  test.servicios('backend', 'test/conexion')
                  expect(test.response.code).to eq(200)
                end
                it '1.2 Validar usuario repetido - Verdadero' do
                    url = 'registro/validar_usuario_repetido?nombre=' + nombre
                    test = App.new(url)
                    test.post()
                    expect(test.response.body).to eq('1')
                end
            end
        end
        describe "2. Validar nombre de usuario repetido - Falso : " do
            arreglo_nombres_usuario = []
            file = File.new("data/nombres_usuario_falso.txt", "r")
            arreglo_nombres_usuario = []
            while (line = file.gets)
                nombre_usuario = line
                arreglo_nombres_usuario.push(nombre_usuario)
            end

            arreglo_nombres_usuario.each do |nombre|
                it '2.1 Conexión con backend-animalitos' do
                  test =App.new('')
                  test.servicios('backend', 'test/conexion')
                  expect(test.response.code).to eq(200)
                end
                it '2.2 Validar usuario repetido - Falso' do
                    url = 'registro/validar_usuario_repetido?nombre=' + nombre
                    test = App.new(url)
                    test.post()
                    expect(test.response.body).to eq('0')
                end
            end
        end
    end
end

def  validar_correo_repetido
    RSpec.describe App do
        describe "3. Validar correo de usuario repetido - Verdadero : " do
            file = File.new("data/correo_usuario_verdadero.txt", "r")
            arreglo_correos_usuario = []
            while (line = file.gets)
                correo = line
                arreglo_correos_usuario.push(correo)
            end

            arreglo_correos_usuario.each do |correo|
                it '3.1 Conexión con backend-animalitos' do
                  test =App.new('')
                  test.servicios('backend', 'test/conexion')
                  expect(test.response.code).to eq(200)
                end
                it '3.2 Validar correo repetido - Verdadero' do
                    url = 'registro/validar_correo_repetido?correo=' + correo
                    test = App.new(url)
                    test.post()
                    expect(test.response.body).to eq('1')
                end
            end
        end

        file = File.new("data/correo_usuario_falso.txt", "r")
        arreglo_correos_usuario = []
        while (line = file.gets)
            correo = line
            arreglo_correos_usuario.push(correo)
        end

        describe "4. Validar correo de correo repetido - Falso : " do
            arreglo_correos_usuario.each do |correo|
                it '4.1 Conexión con backend-animalitos' do
                  test =App.new('')
                  test.servicios('backend', 'test/conexion')
                  expect(test.response.code).to eq(200)
                end
                it '4.2 Validar correo repetido - Falso' do
                    url = 'registro/validar_correo_repetido?correo=' + correo
                    test = App.new(url)
                    test.post()
                    expect(test.response.body).to eq('0')
                end
            end
        end
    end
end

def crear
    file = File.new("data/registro_usuario.txt", "r")
    arreglo_registros = []
    while (line = file.gets)
        data_json_string = line
        arreglo_registros.push(data_json_string)
    end
    RSpec.describe App do
        describe "5. Registrar Información Personal : " do
            arreglo_registros.each do |registro|
                it '5.1 Conexión con backend-animalitos' do
                  test =App.new('')
                  test.servicios('backend', '/test/conexion')
                  expect(test.response.code).to eq(200)
                end
                it '5.2 Registrar Información de Usuario' do
                    url = 'registro/guardar_usuario?data='+registro
                    test = App.new(url)
                    test.post()
                    expect(test.response.body).not_to include('error')
                    expect(test.response.body).to include('Usuario registrado con éxito', 'usuario_id', '"tipo_mensaje":"success"')
                end
            end
        end
    end
end


validar_correo_repetido
validar_usuario_repetido
crear
