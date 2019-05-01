function test_results_consistency(res::nomadResults,param::nomadParameters,eval::Function)

	@test length(res.best_feasible)==param.dimension
	@test right_input_type(res.best_feasible,param.input_types)
	@test length(res.bbo_best_feasible)==length(param.output_types)
	(count_eval,bbo_bf) = eval(res.best_feasible)
	@test bbo_bf ≈ res.bbo_best_feasible



	if res.infeasible
		@test length(res.best_infeasible)==param.dimension
		@test right_input_type(res.best_infeasible,param.input_types)
		@test length(res.bbo_best_infeasible)==length(param.output_types)
		(count_eval,bbo_bi) = eval(res.best_infeasible)
		@test bbo_bi ≈ res.bbo_best_infeasible
	end

	@test result1.bb_eval <= param1.max_bb_eval

	@test param.x0==res.inter_states[1,:]
	for index=2:size(res.inter_states,1)
		xi = res.inter_states[index,:]
		@test right_input_type(xi,param.input_types)
		if length(param.lower_bound)>0
			@test param.lower_bound<=xi
		end
		if length(param.upper_bound)>0
			@test xi<=param.upper_bound
		end
	end


end

function right_input_type(x,it::Vector{String})
	right_type=true
	try
		for i=1:length(it)
			if it[i]=="R"
				convert(Float64,x[i])
			elseif it[i]=="I"
				convert(Int64,x[i])
			elseif it[i]=="B"
				right_type=(x[i] in [0,1])
			end
		end
	catch
		right_type=false
	end
	return right_type
end
