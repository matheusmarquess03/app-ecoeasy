class FirebaseDatum < ApplicationRecord
	def self.recordData
		results = []
		
		base_uri = 'https://ecoeasy-caminhoneiro.firebaseio.com/'

		firebase = Firebase::Client.new(base_uri)

		query = "SELECT s1.user_id AS user_id, s1.work_day AS work_day FROM schedules AS s1\
					WHERE s1.work_day > COALESCE((SELECT MAX(f1.work_day) FROM firebase_data AS f1\
					WHERE f1.user_id = s1.user_id), '1900-01-01')\
					ORDER BY user_id, work_day"
				
		dataList = ActiveRecord::Base.connection.execute(query)
		
		dataList.each do |row|
			recordOneData(firebase, row.fetch('work_day'), row.fetch('user_id'))
		end
		
		return results
	end
	
	def self.recordOneData(firebase, oneWorkDay, oneUserId)
		count = 1
			
		latitudeAnterior = 0
		longitudeAnterior = 0
		
		truck_id = 0
		distance = 0
		
		path = "#{oneWorkDay}/#{oneUserId}"
		
		response = firebase.get(path)
		
		if (response.body != nil)
			has_data = 1
			
			puts "#{path} - #{response.body.keys.size}"
			
			kTotal = response.body.keys.size 
			kTotal = kTotal - 1
			
			rateFirebase = 10 # segundos 
			rateDesired = 300 # segundos (5 minutos)
			rateData = (rateDesired)/(rateFirebase)
			
			for i in (0..kTotal).step(rateData) do
				keyData = response.body.keys[i]
				
				latitude = response.body.fetch(keyData).fetch('latitude').to_f
				longitude = response.body.fetch(keyData).fetch('longitude').to_f
				truck_id = response.body.fetch(keyData).fetch('truck_id')
				
				if(i != 0)
					tmp =  calculaDistancia(latitudeAnterior, longitudeAnterior, latitude, longitude)
					distance = distance + tmp
				end
				
				latitudeAnterior = latitude 
				longitudeAnterior = longitude 
				
				puts "#{i+1}/#{response.body.keys.size} - #{path}::#{latitude}:#{longitude}:#{distance}"
	
			end
		else
			has_data = 0
		end
		 
		createRecord(oneWorkDay, oneUserId, truck_id, has_data, distance)
	end
	
	def self.monthly_collect
	
		collect_list = FirebaseDatum.select("date_part('month',work_day) AS mes, date_part('year', work_day) AS ano, sum(distance) AS distancia").where("work_day IS NOT NULL").group("date_part('month',work_day),date_part('year', work_day)").order("date_part('year',work_day),date_part('month',work_day)")
		
		count = 1
		
		puts "INICIO" 
		
		result_list = ""
		
		collect_list.each do |c|
			
			mes = convertMonth(c.mes)
			ano = "%d" % c.ano
			distancia = "%.2f" % c.distancia 
			
			if count == 1
				result_list = "{y:\'#{mes}/#{ano}\',x:#{distancia}}"
			else 
				result_list = "#{result_list},{y:\'#{mes}/#{ano}\',x:#{distancia}}"
			end
			
			count = count + 1
			
		end
		
		puts "FIM" 
		
		return result_list
	end
	
	def self.convertMonth(mes)
		case mes
			when 1
				return 'Jan'
			when 2
				return 'Fev'
			when 3
				return 'Mar'
			when 4
				return 'Abr'
			when 5
				return 'Mai'
			when 6
				return 'Jun'
			when 7
				return 'Jul'
			when 8
				return 'Ago'
			when 9
				return 'Set'
			when 10
				return 'Out'
			when 11
				return 'Nov'
			else
				return 'Dez'
		end
	end
	
	private 
	
	
	
	def self.calculaDistancia(latitudeAnterior, longitudeAnterior, latitude, longitude)
		dla = latitude - latitudeAnterior 
		dlo = longitude - longitudeAnterior 
		
		dla = dla*60
		dlo = dlo*60
		
		dla = dla*1852
		dlo = dlo*1852
		
		distance = ((dla**2)+(dlo**2))
		distance = distance**0.5
		
		return distance 
	end
	
	def self.createRecord(work_day, user_id, truck_id, has_data, distance)
		item = FirebaseDatum.new
		
		item.work_day = work_day 
		item.user_id = user_id 
		item.truck_id = truck_id 
		item.has_data = has_data
		item.distance = distance 
		
		item.save
	end
end
