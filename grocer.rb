 #I definitely had to reference the solution to even get started on this, and only solved apply_clearance without referencing the solution several times
 
 def consolidate_cart(cart)
  consolidated_hash = {}
  cart.each do |item|
    item.each do |item_name, item_info_hash|
      if consolidated_hash[item_name]
        consolidated_hash[item_name][:count] += 1 
      else
        consolidated_hash[item_name] = item_info_hash
        consolidated_hash[item_name][:count] = 1 
      end
    end
  end 
  consolidated_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    if cart.keys.include?(coupon_hash[:item])
      if cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
        new_item_name = "#{coupon_hash[:item]} W/COUPON"
        if cart[new_item_name]
          cart[new_item_name][:count] += coupon_hash[:num]
        else
          cart[new_item_name] = {
          :price => (coupon_hash[:cost] / coupon_hash[:num]).round(2),
          :clearance => cart[coupon_hash[:item]][:clearance],
          :count => coupon_hash[:num]
        }
        end
        cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
      end
    end #end of if
  end #end of coupons.each do
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = (item_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons_applied = apply_coupons(consolidated_cart, coupons)
  cart_after_clearance_discount = apply_clearance(cart_with_coupons_applied)
  
  total = 0 
  cart_after_clearance_discount.each do |item, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
