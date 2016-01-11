#<OmniAuth::AuthHash 
# 	credentials=#<OmniAuth::AuthHash 
# 		expires=false 
# 		token="a74835958ebb50c24ff2ecc5f44cffe81a9b268e">
# 	extra=#<OmniAuth::AuthHash 
# 		raw_info=#<OmniAuth::AuthHash 
# 			avatar_url="https://avatars.githubusercontent.com/u/483873?v=3" 
# 			bio=nil 
# 			blog=nil 
# 			collaborators=0 
# 			company=nil 
# 			created_at="2010-11-16T13:56:43Z" 
# 			disk_usage=25457 
# 			email=nil 
# 			events_url="https://api.github.com/users/johndoe/events{/privacy}" 
# 			followers=0 
# 			followers_url="https://api.github.com/users/johndoe/followers" 
# 			following=0 
# 			following_url="https://api.github.com/users/johndoe/following{/other_user}" 
# 			gists_url="https://api.github.com/users/johndoe/gists{/gist_id}" 
# 			gravatar_id="" 
# 			hireable=nil 
# 			html_url="https://github.com/johndoe" 
# 			id=483873 
# 			location=nil 
# 			login="johndoe" 
# 			name=nil 
# 			organizations_url="https://api.github.com/users/johndoe/orgs" 
# 			owned_private_repos=0 
# 			plan=#<OmniAuth::AuthHash 
# 				collaborators=0 
# 				name="free" 
# 				private_repos=0 
# 				space=976562499> 
# 			private_gists=0 
# 			public_gists=1 
# 			public_repos=6 
# 			received_events_url="https://api.github.com/users/johndoe/received_events" 
# 			repos_url="https://api.github.com/users/johndoe/repos" 
# 			site_admin=false 
# 			starred_url="https://api.github.com/users/johndoe/starred{/owner}{/repo}" 
# 			subscriptions_url="https://api.github.com/users/johndoe/subscriptions" 
# 			total_private_repos=0 
# 			type="User" 
# 			updated_at="2016-01-09T08:48:25Z" 
# 			url="https://api.github.com/users/johndoe">
# 		>
# 	info=#<OmniAuth::AuthHash::InfoHash 
# 		email="johndoe@centrum.cz" 
# 		image="https://avatars.githubusercontent.com/u/483873?v=3" 
# 		name=nil 
# 		nickname="johndoe" 
# 		urls=#<OmniAuth::AuthHash 
# 			Blog=nil 
# 			GitHub="https://github.com/johndoe">
# 	> 
# 	provider="github" 
# 	uid="123456"
# >

#Extracts data (name, verfified_email, locale) from Github OAuth2 hash
class User::Identity::Extractor::Github < User::Identity::Extractor
  
  def name
    @name||=(@auth_data.info.name.present? ? @auth_data.info.name : @auth_data.info.nickname)
  end

  def locale
    nil
  end  

  def email
    @email||=@auth_data.info.email
  end

  def verified_email
    nil #@verified_email||=@auth_data.info.email
  end

end
