require 'httparty'

class App
     def initialize(url)
        base_url = 'http://127.0.0.1:5000/'
        @url = URI.encode(base_url + url)
     end

     def get
        @response = HTTParty.get(@url)
     end

     def post
        @response = HTTParty.post(@url)
    end

     def response
        @response
     end

     def body_to_json
        JSON.parse(@response.body)
      end

    def servicios(servicio, url)
        serv = {
          'backend' =>  'http://127.0.0.1:3000/'
        }
        @response = HTTParty.get(serv[servicio] + url)
    end
end
