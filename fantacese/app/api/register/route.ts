import { NextResponse } from 'next/server'
import bcrypt from 'bcryptjs'
import { prisma } from '@/lib/prisma'

export async function POST(request: Request) {
  const { email, password, displayName } = await request.json()

  if (!email || !password || !displayName) {
    return NextResponse.json({ error: 'Campi mancanti' }, { status: 400 })
  }

  const existing = await prisma.user.findUnique({ where: { email } })
  if (existing) {
    return NextResponse.json({ error: 'Email già registrata' }, { status: 409 })
  }

  const passwordHash = await bcrypt.hash(password, 10)

  const user = await prisma.user.create({
    data: { email, passwordHash, displayName },
  })

  return NextResponse.json({ id: user.id, email: user.email })
}