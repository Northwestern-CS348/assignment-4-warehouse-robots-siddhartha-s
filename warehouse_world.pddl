(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?location1 - location ?location2 - location ?robot - robot)
      :precondition (and (at ?robot ?location1) (no-robot ?location2) (connected ?location1 ?location2))
      :effect (and (not (at ?robot ?location1)) (not (no-robot ?location2)) (at ?robot ?location2) (no-robot ?location1))
   )
   
   (:action robotMoveWithPallette
      :parameters (?location1 - location ?location2 - location ?robot - robot ?pallette - pallette)
      :precondition (and (at ?robot ?location1) (at ?pallette ?location1) (no-robot ?location2) (no-pallette ?location2) (connected ?location1 ?location2))
      :effect (and (not (at ?robot ?location1)) (not (free ?robot)) (has ?robot ?pallette) (not (at ?pallette ?location1)) (no-robot ?location1) (no-pallette ?location1) (not (no-robot ?location2)) (not (no-pallette ?location2)) (at ?robot ?location2) (at ?pallette ?location2))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?location - location ?shipment - shipment ?saleitem - saleitem ?pallette - pallette ?order - order)
      :precondition (and (contains ?pallette ?saleitem) (at ?pallette ?location) (orders ?order ?saleitem) (ships ?shipment ?order) (packing-location ?location) (available ?location))
      :effect (and (not (contains ?pallette ?saleitem)) (unstarted ?shipment) (includes ?shipment ?saleitem)))

   (:action completeShipment
      :parameters (?shipment - shipment ?order - order ?location - location)
      :precondition (and (started ?shipment) (packing-at ?shipment ?location) (ships ?shipment ?order) (not (unstarted ?shipment)) (not (complete ?shipment)))
      :effect (and (not (started ?shipment)) (complete ?shipment) (not (packing-at ?shipment ?location)) (available ?location)))

)
