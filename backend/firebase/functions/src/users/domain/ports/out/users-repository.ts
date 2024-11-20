import { UserEntity } from "../../models/user-entity";

export interface UsersRepository {
    findUsersWithFile(fileUid: string): Promise<UserEntity[]>;
    removeFileFromUser(userUid: string, fileUid: string): Promise<void>;
}