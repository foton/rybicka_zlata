def facebook_oauth_hash 
  OmniAuth::AuthHash.new({ provider: "facebook", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         name: "John Doe",
         image: "http://graph.facebook.com/117054972007161/picture",
        }),
      extra: OmniAuth::AuthHash.new({
        raw_info: OmniAuth::AuthHash.new({
          email: "john.doe@gmail.com",  
          locale: 'cs_CZ',
          name: "John Doe",
          timezone: 1,  #Prague/Amsterdam?  FB-dev: float (min: -24) (max: 24) The person's current timezone offset from UTC
          verified: "true"
          })
        })
    })     
end

def github_oauth_hash
  OmniAuth::AuthHash.new({ provider: "github", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         name: "John Doe",
         nickname: "John_doe",
         image: "https://avatars.githubusercontent.com/u/483873?v=3"
        }),
    })    
end

def google_oauth_hash
  OmniAuth::AuthHash.new({ provider: "google", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         first_name: "John",
         image: "https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg",
         last_name: "Doe",
        }),
      extra: OmniAuth::AuthHash.new({
        raw_info: OmniAuth::AuthHash.new({
          email: "john.doe@gmail.com",  
          email_verified: "true",
          locale: 'en'})
        })
    })     
end

def twitter_oauth_hash
  OmniAuth::AuthHash.new({ provider: "twitter", uid: "123456",
    info: OmniAuth::AuthHash.new({ 
       email: "john.doe@gmail.com", 
       name: "John Doe",
       nickname: "john_doe",
       image: "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
      }),
    extra: OmniAuth::AuthHash.new({
      raw_info: OmniAuth::AuthHash.new({
        email: "john.doe@gmail.com",  
        lang: 'en',
        time_zone: 'Chicago',
        name: "John Doe",
        verified: "true"
        })
      })
  })     
end

def linkedin_oauth_hash
  OmniAuth::AuthHash.new({ provider: "linkedin", uid: "123456",
    info: OmniAuth::AuthHash.new({ 
       email: "john.doe@gmail.com", 
       name: "John Doe",
       nickname: "John_doe",
       image: "https://media.licdn.com/mpr/mprx/0_fDcXEjwcCo3FeyuXDfXBEYedCHnoeyuXS7iUEYWcgDCVB4Uk_IFHXOjJuQ9zIUSHaazV5JUgVJ65"
      }),
  })     
end
