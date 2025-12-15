# TeresinhaConnect

Pastoral management system for Santa Teresinha Chapel, designed to facilitate the organization and coordination of parish pastoral activities.

**Current Version:** 1.0.0 (Liturgy Ministry)  
**License:** MIT  
**Author:** Zenio Angelo

---

## 📋 About the Project

TeresinhaConnect is a web platform developed in Ruby on Rails to manage the pastoral activities of Santa Teresinha Chapel. This first version is exclusively focused on **Liturgy Ministry** functionalities, enabling the management of liturgical schedules, readers, and celebrations.

### Main Features (v1.0)

#### 🙏 Liturgical Schedule Management
- Creation and management of celebration schedules
- Definition of date, liturgical color, liturgical season, and solemnities
- Assignment of readers to liturgical functions (1st Reading, Psalm, 2nd Reading, Prayers of the Faithful)
- Drag-and-drop interface for reader assignment
- Detailed view of each schedule with readers ordered by function

#### 📖 Reader Management
- Registration of readers linked to system users
- History of participation in schedules
- Automatic association with Liturgy Ministry
- Profile view with all schedules the reader has participated in

#### 👥 User Management
- Secure authentication system with bcrypt
- User profiles with name, email, and password
- Soft delete for history preservation
- Coordinator and vice-coordinator control

#### 🏛️ Ministry Management
- Ministry registration with coordinator and vice-coordinator
- Member association with ministries
- Coordination status control
- Data protection when deleting ministries (controlled cascade)

---

## 🛠️ Technologies Used

### Backend
- **Ruby:** 3.3.0
- **Rails:** 8.0.1
- **PostgreSQL:** Main database
- **Puma:** Web server

### Frontend
- **Turbo Rails:** SPA-like navigation
- **Stimulus:** Modular JavaScript framework
- **Importmap:** JavaScript module management
- **Custom CSS:** CSS variables and responsive design

### Main Gems
- **acts_as_paranoid (0.10.3):** Soft delete for records
- **bcrypt (3.1.7):** Password encryption
- **devise (4.9):** Authentication system
- **jbuilder:** JSON API builder

### Development Tools
- **RSpec:** Testing framework
- **Factory Bot:** Test fixtures
- **Faker:** Test data generation
- **Shoulda Matchers:** Model test matchers
- **Rubocop:** Static code analysis
- **Brakeman:** Security analysis

### Deployment
- **Kamal:** Docker deployment
- **Thruster:** HTTP caching and compression
- **Solid Cache/Queue/Cable:** Solid backends for Rails

---

## 📦 System Requirements

- **Ruby:** 3.3.0 or higher
- **PostgreSQL:** 12 or higher
- **Node.js:** For asset management (optional with importmap)
- **Git:** For version control

---

## 🚀 Installation and Setup

### 1. Clone the repository
```bash
git clone https://github.com/your-username/TeresinhaConnect.git
cd TeresinhaConnect
```

### 2. Install dependencies
```bash
bundle install
```

### 3. Configure the database

Edit the `config/database.yml` file with your PostgreSQL credentials:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: your_username
  password: your_password
  host: localhost
  port: 5432
```

### 4. Create and configure the database
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Start the server
```bash
rails server
```

Access the application at: `http://localhost:3000`

---

## 🧪 Running Tests

```bash
# Run the entire test suite
bundle exec rspec

# Run specific tests
bundle exec rspec spec/models/grade_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

---

## 📊 Database Structure

### Main Models

- **User:** System users
- **Pastoral:** Parish ministries
- **UserPastoral:** Association between users and ministries
- **Reader:** Liturgy readers (linked to users)
- **Grade:** Liturgical schedules
- **ReaderGrade:** Association between readers and schedules (with liturgical function)

### Main Relationships

```
User ─┬─ has_many → UserPastoral → belongs_to → Pastoral
      └─ has_one → Reader ─→ has_many → ReaderGrade → belongs_to → Grade
```

---

## 🔐 Security

- Encrypted passwords with bcrypt
- CSRF protection enabled
- Soft delete for historical data preservation
- Referential integrity validations
- Security analysis with Brakeman

---

## 🎯 Roadmap

### Current Version (v1.0)
- ✅ Complete Liturgy Ministry management
- ✅ Liturgical schedule system
- ✅ Reader management
- ✅ Drag-and-drop interface

### Future Versions
- 🔄 Features for other ministries (Catechesis, Youth, etc.)
- 🔄 Notification system
- 🔄 Reports and statistics
- 🔄 Mobile application
- 🔄 Integration with official liturgical calendar

---

## 📝 Code Conventions

- Follow Ruby Style Guide
- Use soft delete (acts_as_paranoid) to preserve history
- Validations in Portuguese for error messages
- Comments in Portuguese when necessary
- Tests for all critical functionalities

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/MyFeature`)
3. Commit your changes (`git commit -m 'Add MyFeature'`)
4. Push to the branch (`git push origin feature/MyFeature`)
5. Open a Pull Request

---

## 📄 License

This project is under the MIT license. See the [LICENCE](LICENCE) file for more details.

---

## 👤 Author

**Zenio Angelo**

---

## 📧 Contact and Support

For questions, suggestions, or to report issues, open an issue in the project repository.

---

**Developed with ❤️ for Santa Teresinha Chapel**
