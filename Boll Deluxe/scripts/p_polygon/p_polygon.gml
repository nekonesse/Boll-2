// p_polygon
#macro INT_MAX 2147483647

function GMVector(_x, _y) constructor{
	X = _x;
	Y = _y;
}

function GMTransform(_x, _y, angle) constructor{
	positionX = _x;
	positionY = _y;
	Sin = sin(degtorad(angle));
	Cos = cos(degtorad(angle));
}

function GMTransform_Vector(vector, angle) constructor{
	positionX = vector.X;
	positionY = vector.Y;
	Sin = sin(degtorad(angle));
	Cos = cos(degtorad(angle));
}

function VT_Transform(v, transformation)
{
	return new GMVector(transformation.Cos * (v.X) - transformation.Sin * v.Y + transformation.positionX, 
						transformation.Sin * v.X + transformation.Cos * v.Y + transformation.positionY);
}

function CreateBoxVertices(width, height)
{
	var vertices = array_create(4, noone);
	var left = -width / 2;
	var right = left + width;
	var bottom = -height / 2;
	var top = bottom + height;
	
	vertices[0] = new GMVector(left, top);
	vertices[1] = new GMVector(right, top);
	vertices[2] = new GMVector(right, bottom);
	vertices[3] = new GMVector(left, bottom);
	
	return vertices;
}

function CreateBoxFromBounding(sprindex, xscale = 1, yscale = 1)
{
	var width = ((sprite_get_bbox_right(sprindex) - sprite_get_bbox_left(sprindex)) * xscale) div 1;
	var height = ((sprite_get_bbox_bottom(sprindex) - sprite_get_bbox_top(sprindex)) * yscale) div 1;
	var xoffset = (sprite_get_xoffset(sprindex) * xscale) div 1;
	var yoffset = (sprite_get_yoffset(sprindex) * yscale) div 1;
	
	
	var vertices = array_create(4, noone);
	var left = (-width / 2) + xoffset - 1;
	var right = left + width;
	var bottom = (-height / 2) + yoffset;
	var top = bottom + height;
	
	vertices[0] = new GMVector(left, top);
	vertices[1] = new GMVector(right, top);
	vertices[2] = new GMVector(right, bottom);
	vertices[3] = new GMVector(left, bottom);
	
	return vertices;
}

function obj_update_poly_from_bounding(obj, xscale = 1, yscale = 1)
{
	var width = ((sprite_get_bbox_left(obj.sprite_index) - sprite_get_bbox_right(obj.sprite_index)) * xscale) div 1;
	var height = ((sprite_get_bbox_top(obj.sprite_index) - sprite_get_bbox_bottom(obj.sprite_index)) * yscale) div 1;
	//var xoffset = (sprite_get_xoffset(obj.sprite_index) * xscale) div 1;
	//var yoffset = (sprite_get_yoffset(obj.sprite_index) * yscale) div 1;
	

	var left = (-width / 2);
	var right = left + width;
	var bottom = (-height / 2);
	var top = bottom + height;
	
	obj.vertices[0].X = left;
	obj.vertices[0].Y = top;
	
	obj.vertices[1].X = right;
	obj.vertices[1].Y = top;
	
	obj.vertices[2].X = right;
	obj.vertices[2].Y = bottom;
	
	obj.vertices[3].X = left;
	obj.vertices[3].Y = bottom;
}

function player_update_poly_from_hitsize(obj)
{
	var left = (-obj.hit_sizex);
	var right = left + (obj.hit_sizex * 2);
	var bottom = (-obj.hit_sizey);
	var top = bottom + (obj.hit_sizey * 2);
	
	obj.vertices[0].X = left;
	obj.vertices[0].Y = top;
	
	obj.vertices[1].X = right;
	obj.vertices[1].Y = top;
	
	obj.vertices[2].X = right;
	obj.vertices[2].Y = bottom;
	
	obj.vertices[3].X = left;
	obj.vertices[3].Y = bottom;	
}

// transformUpdateRequired should be set to true

function GetTransformedVertices(obj = self,doOffset, xoff, yoff, forceCenter = false)
{
	if (doOffset == undefined)
		doOffset = true;
		
	xoff = ((xoff == undefined) ? 0 : xoff);
	yoff = ((yoff == undefined) ? 0 : yoff);
	
	var vdist = obj.vertices[2].Y - obj.vertices[0].Y;
	
	
	
	
	if (obj.transformUpdateRequired)
	{
		var xo = ((doOffset) ? (-sprite_xoffset) : 0);
		var yo = ((doOffset) ? (-sprite_yoffset) : 0);
		
		var newy = y + yo + yoff;
		var newx = x + xo + xoff;
		
		// the centering issues are driving me up the wall, so it's PAIN TIME
		if (forceCenter)
		{
			newx = x;
			newy = bbox_bottom - (vdist div 2);
		}
		
		var transform = new GMTransform(newx, newy, obj.polyangle);
		
		var i=0;
		repeat (array_length(obj.vertices))
		{
			var v = obj.vertices[i];
			obj.transformedVertices[i] = VT_Transform(v, transform);
			i++;
		}
	}
	
	return obj.transformedVertices;
}

function vector_add(a, b)
{
	return new GMVector(a.X + b.X, a.Y + b.Y);
}

function vector_sub(a, b)
{
	return new GMVector(a.X - b.X, a.Y - b.Y);
}

function vector_mul(v, s)
{
	return new GMVector(v.X * s, v.Y * s);
}

function move_polygon(poly, amount)
{
	poly.position = vector_add(poly.position, amount);
	poly.transformUpdateRequired = true;
}

function move_obj_by_poly(obj, amount, avoidtileclip = false, tileobj = o_tile)
{
	var newx, newy, clipping;
	
	newx = obj.x + amount.X;
	newy = obj.y + amount.Y;
	
	clipping = obj_place_meeting(obj,newx,newy,tileobj);
	
	//show_debug_message("clip: "+string(clipping));
	
	if ((!avoidtileclip)||(!clipping))
	{
		obj.x += amount.X;
		obj.y += amount.Y;
	
		obj.transformUpdateRequired = true;
	}
	
	return [((avoidtileclip) ? clipping : false), (newx - obj.x), (newy - obj.y)];
}

function vector_get_length(value)
{
	return sqrt(value.X * value.X + value.Y * value.Y);
}

function vector_normalize(v)
{
	var inv = (1 / sqrt(v.X * v.X + v.Y * v.Y));
	return new GMVector(v.X * inv, v.Y * inv);
}

function IntersectPolygons(obj = self,verticesA, verticesB)
{
	var normal = new GMVector(0,0);
	var pdepth = INT_MAX;
	
	var i=0;
	repeat (array_length(verticesA))
	{
		
		var va = verticesA[i];
		var vb = verticesA[(i + 1) % array_length(verticesA)];
		
		var edge = vector_sub(vb, va);
		var axis = new GMVector(-edge.Y, edge.X);
		axis = vector_normalize(axis);
		
		var minmaxA = ProjectVertices(verticesA, axis);
		
		var minA = array_get(minmaxA, 0);
		var maxA = array_get(minmaxA, 1);
		
		minmaxA = [];
		
		var minmaxB = ProjectVertices(verticesB, axis);
		
		var minB = array_get(minmaxB, 0);
		var maxB = array_get(minmaxB, 1);
		
		minmaxB = [];
		
		if (minA >= maxB || minB >= maxA)
			return false;
			
		var axisDepth = min(maxB - minA, maxA - minB);
		
		if (axisDepth < pdepth)
		{
			pdepth = axisDepth;
			normal = axis;
		}
		i++;
	}
	
	var j=0;
	repeat (array_length(verticesB))
	{
		var va = verticesB[j];
		var vb = verticesB[(j + 1) % array_length(verticesB)];
		
		var edge = vector_sub(vb, va);
		
		var axis = new GMVector(-edge.Y, edge.X);
		axis = vector_normalize(axis);
		
		
		var minmaxA = ProjectVertices(verticesA, axis);
		
		var minA = array_get(minmaxA, 0);
		var maxA = array_get(minmaxA, 1);
		
		minmaxA = [];
		
		var minmaxB = ProjectVertices(verticesB, axis);
		
		var minB = array_get(minmaxB, 0);
		var maxB = array_get(minmaxB, 1);
		
		minmaxB = [];
		
		if ((minA >= maxB) || (minB >= maxA))
			return false;
			
		var axisDepth = min(maxB - minA, maxA - minB);
		
		if (axisDepth < pdepth)
		{
			pdepth = axisDepth;
			normal = axis;
		}
		j++;
	}
	
	//pdepth /= vector_get_length(normal);
	//normal = vector_normalize(normal);
	
	var centerA = FindArithmeticMean(verticesA);
	var centerB = FindArithmeticMean(verticesB);
	
	var vectordir = vector_sub(centerB, centerA);
	
	if (vector_dot(vectordir, normal) < 0)
		normal = vector_mul(normal, -1);
	
	obj.datapacket = [normal, pdepth];
	
	return true;
}

function vector_dot(a, b)
{
	return (a.X * b.X) + (a.Y * b.Y);
}

function FindArithmeticMean(vertices)
{
	var sumX = 0;
	var sumY = 0;
	
	var i=0;
	repeat (array_length(vertices))
	{
		var v = vertices[i];
		sumX += v.X;
		sumY += v.Y;
		i++;
	}
	
	return new GMVector(sumX / array_length(vertices), sumY / array_length(vertices));
}

function ProjectVertices(vertices, axis)
{
	var _min = INT_MAX;
	var _max = -INT_MAX;
	
	var i=0;
	repeat (array_length(vertices))
	{
		var v = vertices[i];
		var proj = vector_dot(v, axis);
		
		if (proj < _min)
			_min = proj;
		
		if (proj > _max)
			_max = proj;
		i++;
	}
	
	
		
	return [_min, _max];
}

function init_box_poly()
{
	vertices = array_create(4, noone);
	transformedVertices = array_create(4, noone);
	transformUpdateRequired = true;
	newObjectOverride = true;
	
	polyangle = image_angle div 1;
	polyfloor = [false, 0];
	
	poly_x_prev = x;
	poly_y_prev = y;
	rot_prev = polyangle;
}

function draw_box_poly(obj = self)
{
	var vt = obj.transformedVertices;
	
	if (!vt[0])
	{
		show_debug_message("No vertices to draw.");
		return;
	}
	
	draw_line(vt[0].X,vt[0].Y,vt[1].X,vt[1].Y);
	draw_line(vt[1].X,vt[1].Y,vt[2].X,vt[2].Y);
	draw_line(vt[2].X,vt[2].Y,vt[3].X,vt[3].Y);
	draw_line(vt[3].X,vt[3].Y,vt[0].X,vt[0].Y);	
}

function P_PolygonManager(obj = self, doOffset = false, xoff = 0, yoff = 0)
{
	if ((obj.x != obj.poly_x_prev)||(obj.y != obj.poly_y_prev)||(obj.polyangle != obj.rot_prev)||(obj.newObjectOverride))
	{
		obj.transformUpdateRequired = true;
		obj.newObjectOverride = false;
	}
	else
		obj.transformUpdateRequired = false;

	var bodyA = obj;
	var verticesA = GetTransformedVertices(obj,doOffset,(obj.sprite_xoffset + xoff) div 1, (obj.sprite_yoffset + yoff) div 1);
}

function setup_box_poly(obj,override = undefined)
{
	with(obj)
		init_box_poly();
	
	if object_index!=oPolyCollider {
		var h = ((y-hit_sizey) - (y+hit_sizey)) div 1;
		var w = ((x-hit_sizex) - (x+hit_sizex)) div 1;
	} else {
		var h = ((sprite_get_bbox_top(obj.sprite_index) - sprite_get_bbox_bottom(obj.sprite_index)) * obj.image_yscale) div 1;
		var w = ((sprite_get_bbox_left(obj.sprite_index) - sprite_get_bbox_right(obj.sprite_index)) * obj.image_xscale) div 1;
	}
	
	if (override != undefined)
		w = override;
	
	obj.vertices = CreateBoxVertices(w, h);
	
	obj.poly_width = abs(w);
	obj.poly_height = abs(h);
	
	if (abs(obj.image_angle))
		obj.polyangle = -obj.image_angle div 1;

	obj.linecolor = c_white;
	obj.resetangle = false;
	obj.datapacket = undefined;
	obj.polycheck = 0;
}