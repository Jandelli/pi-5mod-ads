const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const app = express();

// Permite que qualquer origem faça requisição à API
app.use(cors());

// Configuração do banco de dados PostgreSQL
const pool = new Pool({
  connectionString: 'postgresql://neondb_owner:npg_ZYiwOW4Q3Ahn@ep-long-bonus-a5n0on2l-pooler.us-east-2.aws.neon.tech/neondb?sslmode=require',
});

// Middleware para permitir requisições JSON
app.use(express.json()); 

// Conectar ao banco de dados e exibir os usuários na tabela "User"
pool.connect()
  .then(client => {
    console.log("Conexão bem-sucedida ao banco de dados!");

    // Consultar todos os usuários na tabela "User"
    client.query('SELECT * FROM "User"')
      .then(res => {
        console.log('Usuários da tabela "User":', res.rows);
      })
      .catch(err => {
        console.error('Erro ao consultar os usuários:', err);
      })
      .finally(() => client.release());
  })
  .catch(err => {
    console.error('Erro ao conectar ao banco de dados:', err);
  });

// Rota de login
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Ajustar para verificar o usuário correto no banco de dados
    const result = await pool.query('SELECT * FROM "User" WHERE email = $1 AND password = $2', [email, password]);

    if (result.rows.length > 0) {
      res.status(200).json({ message: 'Login bem-sucedido', user: result.rows[0] });
    } else {
      res.status(401).json({ message: 'Email ou senha inválidos' });
    }
  } catch (err) {
    console.error('Erro ao processar a requisição:', err);
    res.status(500).json({ message: 'Erro ao processar a requisição' });
  }
});

// Porta para o servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
