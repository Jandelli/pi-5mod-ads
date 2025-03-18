const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.create({
    data: {
      email: 'ana@exemplo.com',
      password: 'senha123', // Lembre-se de que as senhas devem ser armazenadas de forma segura (hashing)!
    },
  });

  console.log('Usuário criado:', user);
}

main()
  .catch(e => {
    throw e
  })
  .finally(async () => {
    await prisma.$disconnect()
  });
