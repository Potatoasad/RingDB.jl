struct Database{K,T,L,M,S}
	filepath::K
	py_pointer::T
	posterior_db::L
	strain_db::M
	event::S
	cosmo::Bool
end


function resolve_dir(filepath)
	if (filepath[1] == '.') & (filepath[2] == '/') 
		# Relative Filepath
		return joinpath(pwd(), filepath[3:end])
	elseif (filepath[1] == '~') & (filepath[2] == '/')
		return joinpath(homedir(), filepath[3:end])
	else
		return filepath
	end
end

function Database(filepath; cosmo=false)
	ringdb = pyimport("ringdb")
	db_func = ringdb.Database
	absolute_filepath = resolve_dir(filepath)
	db = db_func(absolute_filepath)
	db.initialize()
	DB = Database(absolute_filepath, db, db.PosteriorDB, db.StrainDB, db.event, cosmo)
	DB.posterior_db.cosmo = cosmo
	DB
end