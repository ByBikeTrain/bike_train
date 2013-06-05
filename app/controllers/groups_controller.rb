require "httparty"

class GroupsController < ApplicationController

    include HTTParty

	def index
    	@groups = Group.paginate(page: params[:page])
    	@addresses = Address.all
    	respond_to do |format|
      		format.html 
      		format.json { render :json => {:groups => @groups,
      										:addresses => @addresses}
      					 }
    	end
  	end

  	def new
  		@group = Group.new
  		@origin_address = Address.new
  		@destination_address = Address.new
  		@group.users.build
  		@group.groupMemberships.build

  		respond_to do |format|
      		format.html 
      		format.json { render json: @group }
    	end
  	end

  	def create
  	    logger.debug "&&&&&&&&&&&&&&&&&&"
  	    logger.debug params[:destination_address][:line_address]
  	    
   	    origin_geocoded = geocodeAddress params[:origin_address][:line_address]
	    destination_geocoded = geocodeAddress params[:destination_address][:line_address]

        params[:origin_address][:lat] = origin_geocoded["lat"]
        params[:origin_address][:lng] = origin_geocoded["lng"]
        params[:destination_address][:lat] = destination_geocoded["lat"]
        params[:destination_address][:lng] = destination_geocoded["lng"]
  	    
	    @group = Group.new(params[:group])
	   	
	   	@origin_address = Address.create(params[:origin_address])
		@destination_address = Address.create(params[:destination_address])
		        
		@destination_address.lat = destination_geocoded["lat"]
        @destination_address.lng = destination_geocoded["lng"]

	    @group.origin_address_id = @origin_address.id
	    @group.destination_address_id = @destination_address.id
	    
        @group.origin_address_lat = origin_geocoded["lat"]
        @group.origin_address_lng = origin_geocoded["lng"]
        @group.destination_address_lat = destination_geocoded["lat"]
        @group.destination_address_lng = destination_geocoded["lng"]
        
        @group.origin_address_line = params[:origin_address][:line_address]
        @group.destination_address_line = params[:destination_address][:line_address]

	    
        directions = getDirections(origin_geocoded["lat"], origin_geocoded["lng"], destination_geocoded["lat"], destination_geocoded["lng"])

        route = Route.new
        route.save!
        
        logger.debug directions.parsed_response["routes"][0]["legs"][0]["steps"]
        
        #count for the order of the route
        x = 0
        
        for direction in directions.parsed_response["routes"][0]["legs"][0]["steps"]
            waypoint = Waypoint.new
            waypoint.lat = direction["start_location"]["lat"]
            waypoint.lng = direction["start_location"]["lng"]
            waypoint.save!
                        
            route.waypoints << waypoint
            
            #find the waypoint join table
            waypoints_route = route.waypoints_routes.where(:route_id => route.id, :waypoint_id => waypoint.id).first            
            waypoints_route.order = x
            waypoints_route.save
            
            #increment the leg count
            x = x + 1
            #route.waypoints.create(:lat => direction["start_location"]["lat"], :lng => direction["start_location"]["lng"])
        end
        
        
=begin
	    if @group.save
	      
	      flash[:success] = "Awesome, your a group owner!"
	      redirect_to @group
	    else
	      render "new"      
	    end
=end

	    respond_to do |format|
	    	if @group.save
	    	
		        format.html { redirect_to @group, notice: 'Group was successfully created.' }
		        format.json { render json: @group, status: :created, location: @group }
		    else
		        format.html { render action: "new" }
		        format.json { render json: @group.errors, status: :unprocessable_entity }
		    end
	    end
  	end

  	def show
   		@group = Group.find(params[:id])
 		@origin_address = Address.find(@group.origin_address_id)
  		@destination_address = Address.find(@group.destination_address_id)

  		respond_to do |format|
	      format.html # show.html.erb
	      format.json { render :json => {:group => @group,
	      									:origin_address => @origin_address,
	      									:destination_address => @destination_address}
	      								}
	    end
  	end
  	
  	def search
  	  if(params)
  	     
  	      logger.debug "*********** params ************"
  		  logger.debug params
  		  
  		  origin_geocoded = geocodeAddress params["origin"]
  		  destination_geocoded = geocodeAddress params["destination"]
  		  
  		  logger.debug origin_geocoded
  		  logger.debug destination_geocoded

          #to say this is hacky is an understatement.  it'll work OK for NYC, but fail everywhere else, I actually have no idea the distance I'm looking at
          #this algorithm is actually really tough, there's a lot of origin/destination/time considerations to take into account
          
          possible_group_matches = Group.where("origin_address_lat > ? AND origin_address_lat < ? AND destination_address_lat > ? AND destination_address_lng < ?", origin_geocoded["lat"] - 0.02, origin_geocoded["lat"] + 0.02, destination_geocoded["lng"] - 0.02, destination_geocoded["lng"] + 0.02)

          @groups = possible_group_matches
                    
      end
  	end

    def join
        group = Group.find(params[:id])
        
        if(!group.users.include? current_user)
            group.users << current_user        
            redirect_to "/groups/#{group.id}", :notice => "You're now part of the ride!"
        else 
            redirect_to "/groups/#{group.id}", :alert => "You're already a member of this ride."
        end
    end
    
    def leave
        group = Group.find(params[:id])
        
        if(group.users.include? current_user)
            group.users.delete current_user
            redirect_to "/groups/#{group.id}", :notice => "You've left this group."
        else
            redirect_to "/groups/#{group.id}", :notice => "You can't leave a group you're not a member of."        
        end
        
    end
=begin
  	def search
  		if(params)
  		  logger.debug "*********** params ************"
  		  logger.debug params
  		  
  		  origin_geocoded = geocodeAddress params["origin"]
  		  destination_geocoded = geocodeAddress params["destination"]
  		  

  		  logger.debug origin_geocoded
  		  logger.debug destination_geocoded
  		  
  		  #get bike route between two points
  		  directions = getDirections origin_geocoded["lat"], origin_geocoded["lng"], destination_geocoded["lat"], destination_geocoded["lng"]
  		  #compare each point with what is already in the database
  		  
  		  matching_routes = []
  		  
  		  for direction in directions.parsed_response["routes"][0]["legs"][0]["steps"]
            matching_waypoints = Waypoint.where("lat > ? AND lat < ? AND lng > ? AND lng < ?", direction["start_location"]["lat"] - 0.015, direction["start_location"]["lat"] + 0.015, direction["start_location"]["lng"] - 0.015, direction["start_location"]["lng"] + 0.015)
            

            logger.debug matching_waypoints.inspect
            for matching_waypoint in matching_waypoints
                logger.debug matching_waypoint.routes
                
                for route in matching_waypoint.routes
                    if(!matching_routes[route.id])
                        matching_routes[route.id] = 0
                    end
                    
                    matching_routes[route.id] = matching_routes[route.id] + 1
                end
            end
          end
          
          logger.debug "*********** results ************"
          logger.debug matching_routes
          
          highest_route = nil
          
          #why is nil coming in for element 0!!>?!>!>!>!>!
  		  for matching_route in matching_routes
  		      if(!highest_route || matching_routes[matching_route.id] > matching_routes[highest_route.id])
  		          highest_route = matching_routes[matching_route.id]
  		      end
  		  end
  		  
  		  @groups = highest_route.group
  		  
  		else
  		  @groups = nil
  		end
  	end
=end
  	
  	def geocodeAddress address
  	  logger.debug address
  	  result = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json",
  	  :query => {
      	  :address => address,
      	  :sensor => false 
  	  })
  	  
  	  logger.debug "address geocoded ***********"
  	  logger.debug result
  	  logger.debug result.parsed_response["results"][0]["geometry"]["location"]
  	  
  	  return result.parsed_response["results"][0]["geometry"]["location"]
  	end
  	
    def getDirections origin_lat, origin_lng, destination_lat, destination_lng
      result = HTTParty.get("http://maps.googleapis.com/maps/api/directions/json", 
        :query => {
          :origin => "#{origin_lat},#{origin_lng}",
          :destination => "#{destination_lat},#{destination_lng}",
          :sensor => "false",
          :mode => "bicycle"
        })
        
        logger.debug result.inspect
        
        return result
    end

end






















