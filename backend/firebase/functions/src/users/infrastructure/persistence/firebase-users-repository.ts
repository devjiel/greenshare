import * as admin from "firebase-admin";
import { UsersRepository } from "../../domain/ports/out/users-repository";
import { UserEntity } from "../../domain/models/user-entity";

export class FirebaseUsersRepository implements UsersRepository {
    private db = admin.database();

    async findUsersWithFile(fileUid: string): Promise<UserEntity[]> {
        const usersRef = this.db.ref('users');
        const snapshot = await usersRef.once('value');

        const users: UserEntity[] = [];

        snapshot.forEach((child) => {
            const user = child.val() as UserEntity;
            user.uid = child.key as string;
            if (user.available_files?.includes(fileUid)) {
                users.push(user);
            }
        });

        return users;
    }

    async removeFileFromUser(userUid: string, fileUid: string): Promise<void> {

        const userRef = this.db.ref(`users/${userUid}`);
        const snapshot = await userRef.once('value');
        const user = snapshot.val() as UserEntity;

        if (user.available_files) {
            user.available_files = user.available_files.filter(id => id !== fileUid);
            await userRef.update({ available_files: user.available_files });
        }
    }
}