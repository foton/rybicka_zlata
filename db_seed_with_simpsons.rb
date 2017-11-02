# frozen_string_literal: true

def create_test_user!(attrs = {})
  user = User.where(email: test_email_address(attrs)).first
  return user if user.present?

  user = User.new({ name: 'John Doe',
                    email: default_email,
                    password: 'my_Password10' }.merge(attrs))
  user.skip_confirmation!
  raise "User not created! #{user.errors.full_messages.join(';')}" unless user.save
  user
end

def test_email_address(attrs)
  return attrs[:email] if attrs[:email].present?

  default_email = 'john.doe@test.com'
  return default_email if attrs[:name].blank?
  default_email.gsub('john.doe', attrs[:name].parameterize.dasherize.downcase)
end

def create_connection_for(user, conn_hash)
  conn_name = conn_hash[:name]
  conn_email = conn_hash[:email]

  conns = existing_connections_for(user, conn_name, conn_email)

  if conns.blank?
    conn = Connection.new(name: conn_name,
                          email: (conn_email || "#{conn_name}@example.com"),
                          owner_id: user.id)
    raise "Connection not created! #{conn.errors.full_messages.join(';')}" unless conn.save
    user.connections.reload
  elsif conns.size != 1
    raise "Ambiguous match for '#{conn_hash[:connection]}' for user '#{user.username}': " \
          "#{conns.join("\n")}"
  else
    conn = conns.first
  end
  conn
end

def existing_connections_for(user, conn_name, conn_email)
  if conn_email.present?
    user.connections.where(name: conn_name, email: conn_email)
  else
    user.connections.where(name: conn_name)
  end
end

marge = create_test_user!(name: 'Marge')
homer = create_test_user!(name: 'Homer')
bart = create_test_user!(name: 'Bart')
lisa = create_test_user!(name: 'Lisa')
# maggie = create_test_user!(name: 'Maggie')

User::Identity.create!(email: 'foton@centrum.cz',
                       provider: User::Identity::LOCAL_PROVIDER,
                       user: bart) # so I can use Github to log on Bart
User::Identity.create!(email: 'foton.mndp@gmail.com',
                       provider: User::Identity::LOCAL_PROVIDER,
                       user: lisa) # so I can use Google+ to log on Lisa

marge_to_homer_conn = create_connection_for(marge, name: 'Husband', email: homer.email)
marge_to_lisa_conn = create_connection_for(marge, name: 'Daughter', email: lisa.email)

homer_to_bart_conn = create_connection_for(homer, name: 'MiniMe', email: bart.email)

bart_to_lisa_conn = create_connection_for(bart, name: 'Liiiisaaa', email: lisa.email)
bart_to_homer_conn = create_connection_for(bart, name: 'Dad', email: homer.email)
bart_to_marge_conn = create_connection_for(bart, name: 'Mom', email: marge.email)

# using second identity of bart
lisa_to_bart_conn = create_connection_for(lisa,  name: 'Misfit', email: 'foton@centrum.cz')

lisa_to_homer_conn = create_connection_for(lisa, name: 'Dad', email: homer.email)
lisa_to_marge_conn = create_connection_for(lisa, name: 'Mom', email: marge.email)

wish_marge = Wish::FromAuthor.new(
  author: marge,
  title: 'M: Taller hairs ',
  description: 'And deep bluish too! See https://www.google.cz/search?' \
               'q=marge+hair&client=ubuntu&hs=Dpl&channel=fs&tbm=isch&tbo=u&source=univ&sa=X' \
               '&ved=0ahUKEwij3oqq8L_LAhWCYpoKHd2mD8kQsAQIGw&biw=1109&bih=663  (Donors: M:Lisa)'
)
wish_marge.merge_donor_conn_ids([marge_to_lisa_conn.id], marge)
wish_marge.save!

wish_marge_homer = Wish::FromAuthor.new(
  author: marge,
  title: 'M+H: Your parents on holiday',
  description: 'Nice holiday without children. (Donors: M:Lisa, H:Bart)',
  donee_conn_ids: [marge_to_homer_conn.id] # marge is added automagically as author
)
wish_marge_homer.merge_donor_conn_ids([marge_to_lisa_conn.id], marge)
wish_marge_homer.save!
wish_marge_homer.merge_donor_conn_ids([homer_to_bart_conn.id], homer)
wish_marge_homer.save!

wish_bart = Wish::FromAuthor.new(
  author: bart,
  title: 'B: New faster skateboard',
  description: 'The old one is slooooooooooooow! (Donors: B:Lisa, B:Marge, B:Homer )'
)
wish_bart.merge_donor_conn_ids([bart_to_lisa_conn.id,
                                bart_to_homer_conn.id,
                                bart_to_marge_conn.id], bart)
wish_bart.save!

w = Wish::FromAuthor.new(author: lisa,
                         title: 'L+B: Bigger family car',
                         description: 'If you want us to go with You (Donors: L:Marge, L:Homer )')
w.donee_conn_ids = [lisa_to_bart_conn.id]
w.merge_donor_conn_ids([lisa_to_marge_conn.id, lisa_to_homer_conn.id], lisa)
w.save!

w = Wish::FromAuthor.new(
  author: bart,
  title: 'bart wish (shown only to homer)',
  description: 'Motorbike, HD Electra Glide ideally ' \
               '( http://www.autoevolution.com/news/' \
               '2015-harley-davidson-electra-glide-ultra-classic-low-rumored-85470.html ).' \
               'bart is donee, homer is donor'
)
w.merge_donor_conn_ids([bart_to_homer_conn.id], bart)
w.save!

w = Wish::FromAuthor.new(author: lisa,
                         title: 'lisa wish (shown only to bart)',
                         description: 'Tatoo at my spine! Parents will not allow it.' \
                                      ' lisa is donee, bart is donor')
w.merge_donor_conn_ids([lisa_to_bart_conn.id], lisa)
w.save!
