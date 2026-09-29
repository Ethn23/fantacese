import { prisma } from '@/lib/prisma'

export default async function TestDb() {
  const userCount = await prisma.user.count()
  return <div>Utenti nel database: {userCount}</div>
}